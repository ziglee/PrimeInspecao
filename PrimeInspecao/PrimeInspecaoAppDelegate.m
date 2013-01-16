//
//  PrimeInspecaoAppDelegate.m
//  PrimeInspecao
//
//  Created by Cassio Ribeiro on 19/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrimeInspecaoAppDelegate.h"
#import "PrimeInspecaoMasterViewController.h"
#import "SecaoPerguntas.h"
#import "Pergunta.h"

@implementation PrimeInspecaoAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
    PrimeInspecaoMasterViewController *controller = (PrimeInspecaoMasterViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    
    //NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"1.0"]) {
        
        NSLog(@"Versão 1.0! Cadastrando a avaliação padrão");
        [self atualizacao1_0];        
        NSLog(@"Atualizado com sucesso");
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"1.0"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    /*else if (![[NSUserDefaults standardUserDefaults] objectForKey:@"1.1"]) {
        
        NSLog(@"Versão 1.1! Atualizando a avaliação padrão");
        [self atualizacao1_1];
        NSLog(@"Atualizado com sucesso");
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"1.1"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }*/
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PrimeInspecao" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PrimeInspecao.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)atualizacao1_0 {
    SecaoPerguntas *condicoesGeraisDaObra = [NSEntityDescription insertNewObjectForEntityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    condicoesGeraisDaObra.titulo = @"Condições Gerais da Obra";
    condicoesGeraisDaObra.posicao = [NSNumber numberWithInt:0];    
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:condicoesGeraisDaObra.perguntas];
    
    Pergunta *pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:0];
    pergunta.titulo = @"Limpeza do canteiro";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:1];
    pergunta.titulo = @"Limpeza interna das unid.";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:2];
    pergunta.titulo = @"Organização";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:3];
    pergunta.titulo = @"Armazenamento Mat.";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:4];
    pergunta.titulo = @"Utilização equipamentos";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:5];
    pergunta.titulo = @"Desperdício de material";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:6];
    pergunta.titulo = @"Organização dos projetos";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:7];
    pergunta.titulo = @"Terminalidade de serv.";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:8];
    pergunta.titulo = @"Sequência de execução";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:9];
    pergunta.titulo = @"Frente de serv. liberada";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:10];
    pergunta.titulo = @"Frente de serv. em execução";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    condicoesGeraisDaObra.perguntas = tempSet;
    
    
    SecaoPerguntas *qualidadeServExec = [NSEntityDescription insertNewObjectForEntityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    qualidadeServExec.titulo = @"Qualidade dos Serviços Executados";
    qualidadeServExec.posicao = [NSNumber numberWithInt:1];    
    tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:qualidadeServExec.perguntas];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:0];
    pergunta.titulo = @"Formas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:1];
    pergunta.titulo = @"Alvenaria estrutural";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:2];
    pergunta.titulo = @"Alvenaria de vedação";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:3];
    pergunta.titulo = @"Contrapiso";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:4];
    pergunta.titulo = @"Reboco";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:5];
    pergunta.titulo = @"Gesso";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:6];
    pergunta.titulo = @"Laje";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:7];
    pergunta.titulo = @"Portas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:8];
    pergunta.titulo = @"Pintura";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:9];
    pergunta.titulo = @"Cuidados estruturais";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:10];
    pergunta.titulo = @"Juntas de dilatação";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:11];
    pergunta.titulo = @"Condições calçadas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:12];
    pergunta.titulo = @"Cerâmica";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:13];
    pergunta.titulo = @"Inst. hidro";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:14];
    pergunta.titulo = @"Inst. elétrica";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:15];
    pergunta.titulo = @"Peitoril";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:16];
    pergunta.titulo = @"Esquadrias";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:17];
    pergunta.titulo = @"Arrimos";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:18];
    pergunta.titulo = @"Caixas de passagem";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:19];
    pergunta.titulo = @"Muro externo";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:20];
    pergunta.titulo = @"Pavimentação vias";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:21];
    pergunta.titulo = @"Paisagismo interno";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:22];
    pergunta.titulo = @"Paisagismo externo";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    qualidadeServExec.perguntas = tempSet;
    
    
    SecaoPerguntas *canteiroDeObras = [NSEntityDescription insertNewObjectForEntityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    canteiroDeObras.titulo = @"Canteiro de Obras";
    canteiroDeObras.posicao = [NSNumber numberWithInt:2];
    tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:canteiroDeObras.perguntas];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:0];
    pergunta.titulo = @"Betoneira em desnível";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:1];
    pergunta.titulo = @"Tabela de traços";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:2];
    pergunta.titulo = @"Carrinhos padiolas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:3];
    pergunta.titulo = @"Proced. da qualidade";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:4];
    pergunta.titulo = @"Giricas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:5];
    pergunta.titulo = @"Placa de obra";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:6];
    pergunta.titulo = @"Banner - prog de compras";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:7];
    pergunta.titulo = @"Central de argamassa";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:8];
    pergunta.titulo = @"Central de concreto";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:9];
    pergunta.titulo = @"Central de laje içada";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:10];
    pergunta.titulo = @"Central de bloco de concreto";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:11];
    pergunta.titulo = @"Placa de aviso de pagamento";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    canteiroDeObras.perguntas = tempSet;
    
    
    SecaoPerguntas *condicoesDeTrab = [NSEntityDescription insertNewObjectForEntityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    condicoesDeTrab.titulo = @"Condições de Trabalho";
    condicoesDeTrab.posicao = [NSNumber numberWithInt:3];
    tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:condicoesDeTrab.perguntas];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:0];
    pergunta.titulo = @"Conhecimento da NR18";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:1];
    pergunta.titulo = @"Aplicação da NR18";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:2];
    pergunta.titulo = @"Proteção periférica";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:3];
    pergunta.titulo = @"Fechamentos (escada/etc)";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:4];
    pergunta.titulo = @"Utilização de EPI's";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:5];
    pergunta.titulo = @"Bandejas de proteção";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:6];
    pergunta.titulo = @"Vestiários";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:7];
    pergunta.titulo = @"Banheiros";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:8];
    pergunta.titulo = @"Refeitórios";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:9];
    pergunta.titulo = @"Guarda-copos";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:10];
    pergunta.titulo = @"Andaime + tela + rodapé";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:11];
    pergunta.titulo = @"Linha da vida";
    pergunta.tipoSimNao = [NSNumber numberWithInt:0];
    [tempSet addObject:pergunta];
    
    condicoesDeTrab.perguntas = tempSet;
    
    
    SecaoPerguntas *equipamentos = [NSEntityDescription insertNewObjectForEntityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    equipamentos.titulo = @"Equipamentos";
    equipamentos.posicao = [NSNumber numberWithInt:4];
    tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:equipamentos.perguntas];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:0];
    pergunta.titulo = @"Bobcat";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:1];
    pergunta.titulo = @"Perna-de-pau";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:2];
    pergunta.titulo = @"Peneira elétrica";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:3];
    pergunta.titulo = @"Mini-Sky Track";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:4];
    pergunta.titulo = @"Mini-grua";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:5];
    pergunta.titulo = @"Sky Track";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:6];
    pergunta.titulo = @"Plataforma elevatória";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:7];
    pergunta.titulo = @"Betoneira com carregadeira";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:8];
    pergunta.titulo = @"Gabarito metálico porta";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:9];
    pergunta.titulo = @"Gabarito metálico janela";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:10];
    pergunta.titulo = @"Escantilhão";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:11];
    pergunta.titulo = @"Escantilhão graduado";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:12];
    pergunta.titulo = @"Máquina de teste hidro";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    equipamentos.perguntas = tempSet;
    
    
    SecaoPerguntas *novasTecnicas = [NSEntityDescription insertNewObjectForEntityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    novasTecnicas.titulo = @"Aplicação de Novas Técnicas";
    novasTecnicas.posicao = [NSNumber numberWithInt:5];
    tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:novasTecnicas.perguntas];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:0];
    pergunta.titulo = @"Viga pré-moldada ar cond.";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:1];
    pergunta.titulo = @"Viga pré-moldada verga";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:2];
    pergunta.titulo = @"Viga pré-moldada porta";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:3];
    pergunta.titulo = @"Gesso projetado";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:4];
    pergunta.titulo = @"Reboco projetado";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:5];
    pergunta.titulo = @"Pintura projetada";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:6];
    pergunta.titulo = @"Textura projetada";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:7];
    pergunta.titulo = @"Laje içada";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:8];
    pergunta.titulo = @"Peças pré-moldadas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:9];
    pergunta.titulo = @"Tabela progressiva";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:10];
    pergunta.titulo = @"Argam. industrializada";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:11];
    pergunta.titulo = @"Cal líquido";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:12];
    pergunta.titulo = @"Argamassa auto-nivelante";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:13];
    pergunta.titulo = @"Caixinha elétrica no bloco";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:14];
    pergunta.titulo = @"Conhecimento: 'Como fazer?'";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    novasTecnicas.perguntas = tempSet;
    
    
    SecaoPerguntas *materiaisGarg = [NSEntityDescription insertNewObjectForEntityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    materiaisGarg.titulo = @"Materiais Gargalos";
    materiaisGarg.posicao = [NSNumber numberWithInt:6];
    tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:materiaisGarg.perguntas];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:0];
    pergunta.titulo = @"Instalações elétricas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:1];
    pergunta.titulo = @"Instalações hidráulicas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:2];
    pergunta.titulo = @"Redes externas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:3];
    pergunta.titulo = @"Bloco estrutural";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:4];
    pergunta.titulo = @"Laje pré-moldada";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:5];
    pergunta.titulo = @"Isopor para laje";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:6];
    pergunta.titulo = @"Castelo d'água/caixa fibra";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:7];
    pergunta.titulo = @"Caixa ar-condicionado";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:8];
    pergunta.titulo = @"Material impermeab.";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:9];
    pergunta.titulo = @"Guarda-copo varanda";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:10];
    pergunta.titulo = @"Material telhados";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:11];
    pergunta.titulo = @"Mantação de ardósia";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:12];
    pergunta.titulo = @"Peitoril";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:13];
    pergunta.titulo = @"Pedra passa-pratos";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:14];
    pergunta.titulo = @"Filetes e soleiras";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:15];
    pergunta.titulo = @"Cerâmica";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:16];
    pergunta.titulo = @"Bancadas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:17];
    pergunta.titulo = @"Louças";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:18];
    pergunta.titulo = @"Portas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:19];
    pergunta.titulo = @"Esquadrias";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:20];
    pergunta.titulo = @"Corrimão caixa de escada";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:21];
    pergunta.titulo = @"Acabamento fachada";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    materiaisGarg.perguntas = tempSet;
    
    
    SecaoPerguntas *verificacoes = [NSEntityDescription insertNewObjectForEntityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    verificacoes.titulo = @"Verificações";
    verificacoes.posicao = [NSNumber numberWithInt:7];
    tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:verificacoes.perguntas];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:0];
    pergunta.titulo = @"Kit instal. (Hidro peças)";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:1];
    pergunta.titulo = @"Kit instal. (Hidro isomet.)";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:2];
    pergunta.titulo = @"Kit instal. (peças elétricas)";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:3];
    pergunta.titulo = @"Inst. elétricas sondadas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:4];
    pergunta.titulo = @"Caixinhas de elétrica";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:5];
    pergunta.titulo = @"Caixas embutidas Hall";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:6];
    pergunta.titulo = @"Laje nivel 'zero'";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];

    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:7];
    pergunta.titulo = @"Proteção peitoril";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:8];
    pergunta.titulo = @"Proteção esquadria";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];

    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:9];
    pergunta.titulo = @"Proteção degraus de ardósia";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:10];
    pergunta.titulo = @"Prot. caixa de ar-cond.";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:11];
    pergunta.titulo = @"Forma com tábuas/fund.";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:12];
    pergunta.titulo = @"Encunhamento alv. ved.";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:13];
    pergunta.titulo = @"Canaleta cheia antes da laje";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:14];
    pergunta.titulo = @"Laje solta";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:15];
    pergunta.titulo = @"Amarração alvenaria ved.";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:16];
    pergunta.titulo = @"Utilização 'bolachas'";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];

    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:17];
    pergunta.titulo = @"Drenagem definitiva";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:18];
    pergunta.titulo = @"Gás";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];

    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:19];
    pergunta.titulo = @"Check-list das unidades";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];

    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:20];
    pergunta.titulo = @"Gabarito de porta";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:21];
    pergunta.titulo = @"Gabarito de janela";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:22];
    pergunta.titulo = @"Aplicação: 'Como fazer?'";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:23];
    pergunta.titulo = @"Vãos de portas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:23];
    pergunta.titulo = @"Utilização ralo anti-infiltração";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:24];
    pergunta.titulo = @"Cintas rebaixadas para hidro";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];

    verificacoes.perguntas = tempSet;
    
    
    SecaoPerguntas *frentesPriori = [NSEntityDescription insertNewObjectForEntityForName:@"SecaoPerguntas" inManagedObjectContext:self.managedObjectContext];
    frentesPriori.titulo = @"Frentes a Priorizar";
    frentesPriori.posicao = [NSNumber numberWithInt:8];
    tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:frentesPriori.perguntas];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:0];
    pergunta.titulo = @"Terraplanagem";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:1];
    pergunta.titulo = @"Ent. de energia definitiva";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:2];
    pergunta.titulo = @"Calçadas externas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:3];
    pergunta.titulo = @"Muro/gradil";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:4];
    pergunta.titulo = @"Fundações profundas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:5];
    pergunta.titulo = @"Paisagismo externo";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:6];
    pergunta.titulo = @"Lajão/Cintamento";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:7];
    pergunta.titulo = @"Castelo d'água";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:8];
    pergunta.titulo = @"Redes externas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:9];
    pergunta.titulo = @"Pavimentação das ruas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:10];
    pergunta.titulo = @"Reserv. inf./E.T.E.";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:11];
    pergunta.titulo = @"Lazer";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:12];
    pergunta.titulo = @"Pavimentação vagas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:13];
    pergunta.titulo = @"Guarita";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:14];
    pergunta.titulo = @"Alvenaria";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:15];
    pergunta.titulo = @"Inst. de elétrica";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:16];
    pergunta.titulo = @"Inst. de hidro";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:17];
    pergunta.titulo = @"Escada de ardósia";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:18];
    pergunta.titulo = @"Laje içada/pré-moldada";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:19];
    pergunta.titulo = @"Contra-marco";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:20];
    pergunta.titulo = @"Inst. combate a incêndio";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:21];
    pergunta.titulo = @"Contrapiso";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:22];
    pergunta.titulo = @"Peitoril";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:23];
    pergunta.titulo = @"Inst. de gás";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:24];
    pergunta.titulo = @"Esquadria";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:25];
    pergunta.titulo = @"Caixa de ar-condicionado";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:26];
    pergunta.titulo = @"Reboco interno";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:27];
    pergunta.titulo = @"Gesso";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:28];
    pergunta.titulo = @"Pedra dos passa pratos";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:29];
    pergunta.titulo = @"Filetes/Soleiras";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:30];
    pergunta.titulo = @"Cerâmica";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:31];
    pergunta.titulo = @"Forro de gesso";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:32];
    pergunta.titulo = @"Gesso circulação comum";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:33];
    pergunta.titulo = @"Unidades com cobertura";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:34];
    pergunta.titulo = @"Reboco externo";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:35];
    pergunta.titulo = @"Portas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:36];
    pergunta.titulo = @"Pintura";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:37];
    pergunta.titulo = @"Fachada molduras";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:38];
    pergunta.titulo = @"Fachada pintura";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:39];
    pergunta.titulo = @"Telhado";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:40];
    pergunta.titulo = @"Bancadas";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:41];
    pergunta.titulo = @"Cerâmica hall";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:42];
    pergunta.titulo = @"Medidores de energia";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    pergunta = [NSEntityDescription insertNewObjectForEntityForName:@"Pergunta" inManagedObjectContext: self.managedObjectContext];
    pergunta.posicao = [NSNumber numberWithInt:43];
    pergunta.titulo = @"Elevador";
    pergunta.tipoSimNao = [NSNumber numberWithInt:1];
    [tempSet addObject:pergunta];
    
    frentesPriori.perguntas = tempSet;
    
    NSError *error;
    [self.managedObjectContext save:&error];
}

- (void)atualizacao1_1 {
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Pergunta" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"titulo like %@", @"Elevador"];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array != nil) {
        for (Pergunta *p in array) {
            NSLog(@"Pergunta encontrada: %@", p.titulo);
        }
        [moc deleteObject: [array objectAtIndex:0]];                
    }
    
    [self.managedObjectContext save:&error];
}

@end
